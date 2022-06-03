#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT500APO.prw
=================================================================================
||   Funcao: 	MT500APO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Esse ponto de entrada é executado após a eliminação de resíduo 
||	por registro do SC6.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	30/09/2015
=================================================================================
=================================================================================
*/

USER FUNCTION MT500APO()

	LOCAL LRESIDUO		:= PARAMIXB[1]
	LOCAL NRECSC5SP		:= SC5->(RECNO())
	LOCAL cPedPortal	:= ALLTRIM(SC5->C5_NUMOLD)

	// Atualiza Saldo disponível de Crédito
	If LRESIDUO
		U_FINMI003("E", SC5->C5_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO, nil)
	EndIf

	IF (CEMPANT + CFILANT) = "0301" .AND. LRESIDUO .AND. SC5->C5_CLASPED != "A"

		DBSELECTAREA("SC5")
		DBORDERNICKNAME("SC5NUMOLD")
		If DBSEEK( "02" + ALLTRIM( cPedPortal ))
			RECLOCK("SC5",.F.)
			SC5->C5_LIBCOM		:= "2"
			MSUNLOCK()
		EndIf

		SC5->(DbSetOrder(1))
		SC5->(DbGoto(NRECSC5SP))

		RECLOCK("SC5",.F.)
		SC5->C5_STCROSS	:= "FINRES"
		MSUNLOCK()

		RECLOCK("ZC8",.T.)
		ZC8->ZC8_FILIAL := XFILIAL("ZC8")
		ZC8->ZC8_PEDIDO := SC6->C6_NUM
		ZC8->ZC8_ITEM	:= SC6->C6_ITEM
		ZC8->ZC8_CODPRO := SC6->C6_PRODUTO
		ZC8->ZC8_ELIMIN	:= "N"
		MSUNLOCK()

	ENDIF

RETURN