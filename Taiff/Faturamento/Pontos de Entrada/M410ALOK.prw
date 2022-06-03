#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	M410ALOK.prw
=================================================================================
||   Funcao:	M410ALOK
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		EXECUTA ANTES DE ALTERAR PEDIDO VENDA
|| 		Executado antes de iniciar a alteração do pedido de venda
||
|| 		Esta sendo utilizado Status dos Pedidos marca Proart e Processo
|| 	Crossdocing remodelado.
=================================================================================
=================================================================================
||   Autor: Arlete - VETI
||   Data:	04/2013
=================================================================================
=================================================================================
*/

USER FUNCTION M410ALOK()
	
	LOCAL AUSU			:= {}
	LOCAL CUSU			:= ""
	LOCAL LRET			:= .T.
	LOCAL CQUERY 		:= ""
	LOCAL NREGS			:= 0
	LOCAL AVLDPED		:= {}
	Local nQtdVenda
	
	
	/*
	|---------------------------------------------------------------------------------
	|	SE FOR CHAMADO POR MSEXECAUTO NAO PASSA POR ESSA VALIDACAO
	|---------------------------------------------------------------------------------
	*/
	IF L410AUTO
		
		RETURN .T.
		
	ENDIF

	//VALIDA SE E UM PEDIDO DE BENEFICIAMENTO
	If cEmpAnt == "04" .and. cFilAnt='02' .And. SC5->C5_TIPO == "B" .And. IsInCallStack("A410COPIA")
		If !Empty(Posicione("SC6",1,xFilial("SC6")+SC5->C5_NUM,"C6__OPBNFC"))
			MsgStop("Não é permitida a cópia de um pedido de beneficiamento, digite o pedido","M410ALOK")
			Return(.F.)
		EndIf
		
	EndIf
	
	AUSU := PSWRET()
	CUSU := AUSU[1][1]
	
	/*
	|---------------------------------------------------------------------------------
	|	VERIFICA SE STATUS DE SEPARAÇÃO DO PEDIDO PERMITE ALTERAÇÃO
	|	CASO ESTEJA LIBERADO NA EXPEDICAO E TOTALMENTE ATENDIDO, PERMITE NOVA LIBERACAO
	|	LINHAS HABILITADAS EM 3/MAIO/2013 - ARLETE
	|	PROCESSO DA MARCA PROART
	|---------------------------------------------------------------------------------
	*/
	IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__SEPA01",.F.,"") .AND. ALLTRIM(SC5->C5_XITEMC) = "PROART" .AND. (CEMPANT+CFILANT) = (SC5->C5_EMPDES+SC5->C5_FILDES)
		IF SC5->C5_YSTSEP = "G" .AND. !U_ENCERR() .AND. !U_FATPENDL() //PEDIDO NÃO ESTÁ ENCERRADO E NÃO HÁ FATURAMENTO PENDENTE DA LIBERAÇÃO ATUAL
			LRET := .T.              // PERMITE
		ELSEIF SC5->C5_YSTSEP $ "SCG" // BLOQUEAR SE O STATUS FOR DIFERENTE DE " EN"
			MSGALERT("STATUS DO PEDIDO "+SC5->C5_NUM+" NÃO PERMITE ALTERAÇÃO. ENTRE EM CONTATO COM O DEPARTAMENTO DE EXPEDIÇÃO.")
			LRET := .F. // NÃO PERMITE
			/*
			|---------------------------------------------------------------------------------
			|	INCLUÍDO A FUNCAO VERLOC21 PARA QUE SOMENTE PEDIDOS QUE SEJAM DO ARMAZEM 21.
			|	EDSON HORNBERGER - 06/05/2014
			|---------------------------------------------------------------------------------
			*/
		ELSEIF SC5->C5_XLIBCR='L' .AND. EMPTY(SC5->C5_BLQ)	.AND. !(SC5->C5_YSTSEP $  'E') .AND. SC5->C5_YSTSEP $  ' N'	.AND.	SC5->C5_YFMES = 'S' .AND. U_VERLOC21()
			MSGALERT("STATUS DO PEDIDO "+SC5->C5_NUM+" NÃO PERMITE ALTERAÇÃO. O PEDIDO ESTÁ FATURADO ANTECIPADO, E TEM UMA SEPARAÇÃO NÃO INICIADA.")
			LRET := .F. // NÃO PERMITE
		ELSE
			LRET := .T. // PERMITE
		ENDIF
	ENDIF
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|		Informa ao usuario que nao podera ser alterado a quantidade dos itens
	|	de pedidos com copia no CD quando em alteração
	|=================================================================================
	*/
	
	IF (CEMPANT + CFILANT) = "0301" .AND. ALLTRIM(SC5->C5_CLASPED) $ "V|X" .AND. ALTERA
		
		CQUERY := "SELECT COUNT(*) AS QTDREG FROM " + RETSQLNAME("SC5") + " WHERE C5_FILIAL = '02' AND C5_NUMORI = '" + SC5->C5_NUM + "' AND C5_CLIORI = '" + SC5->C5_CLIENT + "' AND C5_LOJORI = '" + SC5->C5_LOJAENT + "' AND D_E_L_E_T_ = ''"
		
		IF SELECT("TMP") > 0
			
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			
		ENDIF
		
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		NREGS := TMP->QTDREG
		
		IF NREGS > 0
			
			MSGSTOP("Pedido já tem cópia na Empresa TaiffProart Extrema CD!" + ENTER + "As quantidades dos itens deste Pedido não podem ser alterados!","ATENÇÃO")
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			
			CQUERY := "SELECT SUM(C6_QTDVEN) AS QTDVEN FROM " + RETSQLNAME("SC6") + " WHERE C6_FILIAL = '" + XFILIAL ("SC6") + "' AND C6_NUM = '" + SC5->C5_NUM + "' AND D_E_L_E_T_ = ''"
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			
			/*
			|---------------------------------------------------------------------------------
			|	Cria variaveL GlobaL onde será salvo a Quantidade antes da alteração do Pedido
			|---------------------------------------------------------------------------------
			*/
			//AVLDPED := {.T.,TMP->QTDVEN}
			
			aadd(AVLDPED,{.T.,TMP->QTDVEN})
			PUTGLBVARS("aGlbMT410",AVLDPED)
			
		ELSE
			
			//AVLDPED := {.F.,0}
			aadd(AVLDPED,{.F.,0})
			PUTGLBVARS("aGlbMT410",AVLDPED)
			
		ENDIF
		
	ENDIF
	/*
	Consulta OS do pedido de venda
	*/
	IF (CEMPANT + CFILANT) = "0302" .AND. ALTERA
		IF SELECT("TMP") > 0
			
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			
		ENDIF
		
		CQUERY := "SELECT ISNULL(SUM(C9_QTDLIB),0) AS QTDLIB FROM " + RETSQLNAME("SC9") + " WHERE C9_FILIAL = '" + XFILIAL ("SC9") + "' AND C9_PEDIDO = '" + SC5->C5_NUM + "' AND D_E_L_E_T_ = ''"
		CQUERY += " AND C9_ORDSEP != '' AND C9_NFISCAL = '' AND C9_XITEM IN ('1','2') "
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		
		
		If TMP->QTDLIB > 0
			MSGALERT("STATUS DO PEDIDO "+SC5->C5_NUM+" NÃO PERMITE ALTERAÇÃO. O PEDIDO ESTÁ COM SEPARACAO EM ANDAMENTO, SOLICITE O ESTORNO DA OS.")
			LRET := .F. // NÃO PERMITE
		ENDIF
	ENDIF
	IF (CEMPANT + CFILANT) = "0302" .AND. SC5->C5_FILDES = "01" .AND. ALTERA .AND. LRET
		
		IF SELECT("TMP") > 0
			
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			
		ENDIF
		
		CQUERY := "SELECT ISNULL(SUM(C9_QTDLIB),0) AS QTDLIB FROM " + RETSQLNAME("SC9") + " WHERE C9_FILIAL = '" + XFILIAL ("SC9") + "' AND C9_PEDIDO = '" + SC5->C5_NUM + "' AND D_E_L_E_T_ = ''"
		CQUERY += " AND C9_ORDSEP != '' AND C9_NFISCAL = '' AND C9_XITEM='1' "
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		
		
		If TMP->QTDLIB > 0
			MSGALERT("STATUS DO PEDIDO "+SC5->C5_NUM+" NÃO PERMITE ALTERAÇÃO. O PEDIDO ESTÁ COM SEPARACAO EM ANDAMENTO, SOLICITE O ESTORNO DA OS.")
			LRET := .F. // NÃO PERMITE
		Else
			nQtdVenda := 0
			
			IF SELECT("TMP") > 0
				
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
				
			ENDIF
			
			CQUERY := "SELECT SUM(C6_QTDVEN) AS QTDVEN FROM " + RETSQLNAME("SC6") + " WHERE C6_FILIAL = '" + XFILIAL ("SC6") + "' AND C6_NUM = '" + SC5->C5_NUM + "' AND D_E_L_E_T_ = ''"
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			
			nQtdVenda := TMP->QTDVEN
			
			IF SELECT("TMP") > 0
				
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
				
			ENDIF
			
			CQUERY := "SELECT MAX(C6_XOPER) AS C6_XOPER FROM " + RETSQLNAME("SC6") + " WHERE C6_FILIAL = '" + XFILIAL ("SC6") + "' AND C6_NUM = '" + SC5->C5_NUM + "' AND D_E_L_E_T_ = ''"
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			
			aadd(AVLDPED,{.T. , nQtdVenda , TMP->C6_XOPER , SC5->C5_CLIENTE , SC5->C5_LOJACLI , SC5->C5_CLASPED , SC5->C5_XITEMC , SC5->C5_TABELA , SC5->C5_CONDPAG })
			PUTGLBVARS("aGlbMT410",AVLDPED)
		EndIf
	Else
		aadd(AVLDPED,{.F.,0})
		PUTGLBVARS("aGlbMT410",AVLDPED)
	EndIf
	
RETURN(LRET)
