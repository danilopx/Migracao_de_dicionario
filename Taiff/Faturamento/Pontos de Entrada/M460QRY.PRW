#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460QRY  ºAutor  ³ Fernando Salvatori º Data ³  07/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento durante o Doc. de Saida                      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460QRY
Local _lStatusFaseII := GetNewPar("MV_ARMCEN",.F.) 
Local _cQuery := paramixb[1]
Local _cFiltro:= ""

Local cUniNeg 	:= Space(TAMSX3("CTD_ITEM")[1]) 			// -- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
//Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
Local aSx1area  := SX1->(Getarea())
Local nSx1opc	:= 0
Local cOCcross := SPACE(12)
Local cCLASSPED:= ""
Local oPesqCbx	:= Nil
Local aClassPed:={"OUTROS","ASTEC","ESTORNO"}
Local aSxkarea  := SXK->(Getarea())
Local cIDtransp	:= SPACE(TAMSX3("A4_COD")[1])
Local cSepMarca	:= ""

/*
|---------------------------------------------------------------------------------
|	Alterado a Funcao que e atribuida a tecla F8 onde foi incluido a Funcao 
|	THISMARK() como parametro.
|
|	Edson Hornberger - 30/07/2014
|---------------------------------------------------------------------------------
*/

SetKey(VK_F6,{|| ATUQUERY()    } )
SetKey(VK_F7,{|| VERPEDIDO()   } )
SetKey(VK_F8,{|| MARCAPEDIDO(THISMARK()) } )

If _lStatusFaseII                     
	@ 00,00 TO 250,400 DIALOG oDlg TITLE " Selecione Unidade de Negocios "
	@ 10,15 say "Unidade de Negocios : "
	@ 10,90 Get cUniNeg SIZE 22,10 PICTURE "@!" F3 "CTD" Valid ExistCpo("CTD",cUniNeg,1)
	@ 25,15 say "Carga Cross: "
	@ 25,90 MSGET cOCcross SIZE 50,10 OF oDlg PIXEL PICTURE "@!"  
	@ 40,15 say "Classe de Pedido: "
	@ 40,90 COMBOBOX oPesqCbx VAR cCLASSPED ITEMS aClassPed SIZE 60,12 PIXEL OF oDlg
	@ 55,15 say "Transportadora : "
	@ 55,90 Get cIDtransp SIZE 22,10 PICTURE "@!" F3 "SA4" Valid IIF(EMPTY(cIDtransp),.T.,ExistCpo("SA4",cIDtransp,1))

	@ 90,070 BMPBUTTON TYPE 01 ACTION CLOSE(oDlg)
	Activate Dialog oDlg centered
	
	If Empty(cUniNeg) .Or. !ExistCpo("CTD",cUniNeg,1)
		Final("Nao permitido Unidade Negocios vazia"," ou valor inválido para Unidade de Negocios")
	EndIf

	SX1->(DbsetOrder(1))
	SXK->(DbsetOrder(1))
	/*
	|---------------------------------------------------------------------------------
	|	Realizado alteracao no fonte Linha 52 passando a pesquisa de 13 para 16, pois
	|	o Consultor Jorge "amarrou" esta pesquisa.
	| 	Edson Hornberger - 11/06/2014
	|---------------------------------------------------------------------------------
	*/
	/* Para o PROTHEUS 12 o grupo de pergunta mudou de 16 para 17 */

	cCLASSPED := Upper(SubStr(Alltrim(cCLASSPED),1,1))

	If SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'17') )
		Reclock('SX1',.F.)
		IF cCLASSPED="E"
			SX1->X1_PRESEL := 8
			nSx1opc := Iif( Alltrim(cUniNeg)=='TAIFF',1,Iif(Alltrim(cUniNeg)=='PROART',2,4) )
		ELSE
			SX1->X1_PRESEL := nSx1opc := Iif( Alltrim(cUniNeg)=='TAIFF',1,Iif(Alltrim(cUniNeg)=='PROART',2,4) )
		ENDIF
		SX1->(MsUnlock())
		cSepMarca := LEFT(cUniNeg,1)
	EndIf
	If SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'18') )
		Reclock('SX1',.F.)
		SX1->X1_CNT01 := cOCcross
		SX1->(MsUnlock())
	EndIf
	If SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'19') )
		Reclock('SX1',.F.)
		SX1->X1_CNT01 := LEFT(cCLASSPED,1)
		SX1->(MsUnlock())
	EndIf
	If SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'20') )
		Reclock('SX1',.F.)
		SX1->X1_CNT01 := cIDtransp
		SX1->(MsUnlock())
	EndIf
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "17" + "U" + __CUSERID) )
		Reclock('SXK',.F.)
		SXK->XK_CONTEUD := LEFT(cUniNeg,1)
		SXK->(MsUnlock())
		cSepMarca := LEFT(cUniNeg,1)
	EndIf
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "18" + "U" + __CUSERID) )
		Reclock('SXK',.F.)
		SXK->XK_CONTEUD := cOCcross
		SXK->(MsUnlock())
	EndIf
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "19" + "U" + __CUSERID) )
		Reclock('SXK',.F.)
		SXK->XK_CONTEUD := Iif( LEFT(cCLASSPED,1) = "E", "3", Iif( LEFT(cCLASSPED,1) = "A", "2", "1" ) )
		SXK->(MsUnlock())
	EndIf
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "20" + "U" + __CUSERID) )
		Reclock('SXK',.F.)
		SXK->XK_CONTEUD := cIDtransp
		SXK->(MsUnlock())
	EndIf
	
	RestArea(aSx1area)
	RestArea(aSxkarea)

	If cCLASSPED == "E"
		Return(ParamIxb[1])
	EndIf

	_cFiltro+= " AND C9_XEMP='"+CEMPANT+"' "
	_cFiltro+= " AND C9_XFIL='"+CFILANT+"' "
	_cFiltro+= " AND C9_XITEM='"+Alltrim(Str(nSx1opc))+"'"
	
	/* O filtro do processo de Cross Docking é valido apenas na filial do CD de SP */
	/* desta forma serão faturados apenas os pedidos correspondente à separação enviada na Carga especifica */
	If !empty(cOCcross) .AND. CEMPANT='03' .AND. CFILANT='01'
		_cFiltro+= " AND C9_NUMOF='" + cOCcross + "'"
	EndIf
	
	/* Tratamento para os pedidos da ASSISTENCIA TECNICA */
	If cCLASSPED = "A" .AND. CEMPANT='03' .AND. CFILANT='01'
		_cFiltro+= " AND C9_LOCAL = '51' "
	ElseIf cCLASSPED != "A" .AND. CEMPANT='03' .AND. CFILANT='01'
		_cFiltro+= " AND C9_LOCAL != '51' "
	EndIf
	

	If CEMPANT = "03" .AND. .NOT. Empty(cIDtransp)
		_cFiltro += " AND ( '" + cIDtransp + "' = (SELECT C5_TRANSP FROM " + RetSqlName("SC5") + " SC5 WHERE C5_FILIAL=C9_FILIAL AND C5_NUM=C9_PEDIDO AND SC5.D_E_L_E_T_='') ) "
	EndIf 

	/* Tratamento para os pedidos que estão disponiveis para fatuamento */
	IF cCLASSPED = "E" .AND. CEMPANT = "03" .AND. CFILANT = "02" 
		_cFiltro+= " AND C9_PRODUTO = '975000092      ' " // produto especifico para o ESTORNO DE CREDITO - ESTOQUE

	ElseIf cCLASSPED != "A" .AND. SC5->(FIELDPOS("C5__DTLIBF")) > 0 .AND. CEMPANT = "03" .AND. CFILANT = "02" 
		_cFiltro += " AND (( ''!=(SELECT C5__DTLIBF FROM " + RetSqlName("SC5") + " SC5 WHERE C5_FILIAL=C9_FILIAL AND C5_NUM=C9_PEDIDO AND SC5.D_E_L_E_T_='') "
		_cFiltro += " AND C9_LOCAL = '21' 
		/* Funcionalidade do projeto de Faturamento somente com Ordem de Separa??o */
		/* Data: 12/05/2020                               Respons?vel: Carlos Torres*/
		/* pedidos TAIFF ou PROART somente ser?o faturados se a ordem de separa??o estiver finalizada */
		/* verificar: armaz?m de processo 21 CB7 com status 9 que seja TAIFF ou PROART */
		If cSepMarca $ "T|P"  
			_cFiltro += " AND C9_ORDSEP!='' "
			_cFiltro += " AND '9' = (SELECT CB7_STATUS FROM CB7030 CB7 WHERE CB7_FILIAL=C9_FILIAL AND CB7_ORDSEP=C9_ORDSEP AND CB7.D_E_L_E_T_='') "
		EndIf
		/* Fim do controle */
		_cFiltro += " ) OR (C9_LOCAL != '21' AND C9_NFISCAL='') )"
	EndIf
	
	 
	_cQuery += _cFiltro

	//MemoWrite("M460QRY_filtro_SC9.sql",_cQuery)
EndIf

Return (_cQuery) 

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuQuery ºAutor  ³ Fernando Salvatori º Data ³  07/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza a Query do Documento de Saida                     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ATUQUERY()

SC9->( MsSeek( xFilial("SC9") ))

Return Nil

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VERPEDIDOºAutor  ³ Fernando Salvatori º Data ³  07/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualiza os pedidos de venda                              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VERPEDIDO()

Local aArea := GetArea()

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial('SC5')+SC9->C9_PEDIDO))

MsAguarde({||A410Visual("SC5",SC5->(RECNO()),2)})

RestArea(aArea)
Return Nil

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MARCAPEDIDºAutor  ³ Fernando Salvatori º Data ³  07/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca os pedidos da mesma numeracao                        º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MARCAPEDIDO(_cMARK)

Local cPedido := SC9->C9_PEDIDO
Local _CodCli := SC9->(C9_CLIENTE + C9_LOJA)
Local _SC9Ord := SC9->(IndexOrd())
Local _oMark  := GetMarkBrowse()

If _SC9Ord == 1	//Ordem numero do pedido
	dbSelectArea("SC9")
	dbSeek( xFilial("SC9") + cPedido )
	
	While !Eof() .And. xFilial("SC9") + cPedido == SC9->C9_FILIAL + SC9->C9_PEDIDO
		If Empty(SC9->C9_BLEST) .and. Empty(SC9->C9_BLCRED)
			RecLock("SC9",.F.)
			SC9->C9_OK := _cMARK
			MsUnlock()
		EndIf		
		DbSkip()
	EndDo

ElseIf _SC9Ord == 2  //Ordem codigo de cliente
	DbSelectArea("SC9")
	DbSeek(xFilial("SC9") + _CodCli)
	
	While !Eof() .and. xFilial("SC9") + _CodCli == SC9->(C9_FILIAL + C9_CLIENTE + C9_LOJA)
		If Empty(SC9->C9_BLEST) .and. Empty(SC9->C9_BLCRED)
			RecLock("SC9", .F.)
			SC9->C9_OK := _cMARK
			MsUnlock()
		EndIf		
		DbSkip()
	EndDo
Else
	Aviso("Ordem Invalida", "Para utilizar essa opcao a ordem deve ser Num. Pedido ou Cod. Cliente.", {"Ok"})
EndIf

/*
|---------------------------------------------------------------------------------
|	Incluido atualizacao do Browse.
|
|	Edson Hornberger - 30/07/2014
|---------------------------------------------------------------------------------
*/

_oMark:OBROWSE:REFRESH()
_oMark:REFRESH()

Return Nil
