#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �MTA416PV  �AUTOR  �DANIEL RUFFINO      � DATA �  17/10/12   ���
�������������������������������������������������������������������������͹��
���DESC.     � PONTO DE ENTRADA RESPONSAVEL POR GRAVAR OS CAMPOS DO       ���
���          � OR�AMENTO PARA PEDIDO DE VENDA NA EFETIVA��O DO OR�AMENTO. ���
�������������������������������������������������������������������������͹��
���USO       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/
USER FUNCTION MTA416PV()

	LOCAL _AAREA 		:= GETAREA()
	LOCAL _AAREASC5		:= SC5->(GETAREA())
	LOCAL _AAREASC6		:= SC6->(GETAREA())
	LOCAL _NAUX 		:= PARAMIXB  //NUMERO DA LINHA POSICIONADA
	LOCAL XSA1ALIAS		:= SA1->(GETAREA())
	LOCAL _CMARCAPEDIDO

	/*
	|---------------------------------------------------------------------------------
	|	Variaveis utilizadas para o Copia de Pedidos de Venda da Empresa 03/01 para 
	|	a Empresa 03/02 - CrossDocking
	|---------------------------------------------------------------------------------
	*/
	PRIVATE ACABSC5		:= {}
	PRIVATE ADETSC6		:= {}
	PRIVATE ATMPSC6		:= {}
	PRIVATE LMSERROAUTO	:= .F.
	PRIVATE NREGS		:= 0
	PRIVATE I			:= 0
	PRIVATE AVOL		:= {}
	PRIVATE APEDIDO		:= {}
	PRIVATE LCONT		:= .T.

	//-----------------------------------------------------------------------------------------------
	// ADICIONADO POR THIAGO COMELLI EM 16/10/2012
	// EXECUTA SOMENTE NA EMPRESA E FILIAL SELECIONADOS
	IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__MULT07",.F.,"")

		//----------------------------------------------------------------
		// PARA CORRIGIR A PERDA DO NOME DO CLIENTE NA COLOCA��O DO PEDIDO
		// FOI FOR�ADA A BUSCA DO CLIENTE E CARREGADO O NOME DO CLIENTE
		// NO CAMPO C5_NOMCLI
		//----------------------------------------------------------------
		IF .NOT. SCJ->CJ_XTIPO $ "D|B"
			SA1->(DBSETORDER(1))
			SA1->(DBSEEK( XFILIAL("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ))
		ENDIF
		//----------------------- FIM ------------------------------------


		//----------------------------------------------------------------
		// COMPLEMENTO 
		// AO ATIVAR PARCIALMENTE A DISTRIBUI��O DA MARCA PROART POR EXTREMA
		// FOI TAMB�M FOR�ADA A BUSCA DA COMISSAO PARA PEDIDO DA MARCA PROART
		// DATA: 16/01/2014                           AUTOR: CARLOS TORRES
		//----------------------------------------------------------------
		_CMARCAPEDIDO := ""
		IF SCJ->(FIELDPOS("CJ_XITEMC"))!=0
			_CMARCAPEDIDO := SCJ->CJ_XITEMC
		ENDIF
		IF !EMPTY(SCJ->CJ_XVEND1) .AND. CEMPANT="03" 
			IF _CMARCAPEDIDO='PROART'
				SA3->(DBSETORDER(1))
				IF SA3->(DBSEEK( XFILIAL("SA3") + SCJ->CJ_XVEND1 ))
					M->C5_COMIS1 := SA3->A3_COMIS
				ENDIF
			ELSEIF _CMARCAPEDIDO='TAIFF'
				M->C5_COMIS1 := 0
			ENDIF
		ENDIF
		//----------------------- FIM ------------------------------------

		//----------------------------------------------------------------
		// AO ATIVAR PARCIALMENTE A DISTRIBUI��O DA MARCA PROART POR EXTREMA
		// FOI FOR�ADA A ATUALIZA��O DO CAMPO DE UNIDADE DE NEGOCIO NO PEDIDO
		// DATA: 16/01/2014                           AUTOR: CARLOS TORRES
		//----------------------------------------------------------------
		IF SC5->(FIELDPOS("C5_XITEMC"))!=0
			M->C5_XITEMC := SCJ->CJ_XITEMC   
			_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_XITEMC"} )]		:= SCK->CK_XITEMC 
		ENDIF

		//������������������������������������������������������������Ŀ
		//� ATUALIZA VARIAVEIS DE MEMORIA (CAMPOS C5) PARA QUE A ROTINA �
		//� AUTOMATICA POSSA EXECUTAR GATILHOS OU OUTRAS VALIDACOES     �
		//� NO MOMENTO DA INCLUS�O DO PEDIDO.                           �
		//��������������������������������������������������������������
		M->C5_NUMOLD 	:=		SCJ->CJ_XNUMOLD
		M->C5_TRANSP 	:=		SCJ->CJ_XTRANSP
		M->C5_TIPO 		:=		SCJ->CJ_XTIPO
		M->C5_CLASPED	:=		SCJ->CJ_XCLASPD
		M->C5_VEND1		:=		SCJ->CJ_XVEND1                // VENDEDOR VALIDADO PELA ROTINA DE OR�AMENTO TOTVS
		M->C5_OBSERVA	:=		SCJ->CJ_XOBSERV
		
		IF (SCJ->CJ_XCLASPD = "A" .AND. CEMPANT = "01") // Se for Or�amento da Assist�ncia T�cnica, obtem a mensagem para a nota
			M->C5_MENNOTA := SCJ->CJ_XMENNOT
		ELSE
			M->C5_MENNOTA := "PEDIDO PORTAL: " + SCJ->CJ_XNUMOLD + ENTER	
		ENDIF 
		
		M->C5_TPFRETE	:=		SCJ->CJ_XTPFRTE
		M->C5_PESOL		:=		SCJ->CJ_XPESOL
		M->C5_PBRUTO	:=		SCJ->CJ_XPBRUTO
		M->C5_VOLUME1	:=		SCJ->CJ_XVOLUM1
		M->C5_ESPECI1	:=		SCJ->CJ_XESPEC1
		M->C5_INCISS	:=		SCJ->CJ_XINCISS
		M->C5_PCR2PED	:=		SCJ->CJ_XPCR2PD
		M->C5_VLR2PED	:=		SCJ->CJ_XVLR2PD
		M->C5_PCBOPED	:=		SCJ->CJ_XPCBOPD
		M->C5_VBPRPED	:=		SCJ->CJ_XVBPRPD
		M->C5_PCVBCTR	:=		SCJ->CJ_XPCVBCT
		M->C5_FATPARC	:=		SCJ->CJ_XFATPRC
		M->C5_FATFRAC	:=		SCJ->CJ_XFATFRC
		M->C5_DTPEDPR	:=		SCJ->CJ_XDTPDPR
		M->C5_TIPLIB	:=		SCJ->CJ_XTIPLIB
		M->C5_DTAPPO	:=		SCJ->CJ_XDTAPPO
		M->C5_HRAPPO	:=		SCJ->CJ_XHRAPPO
		M->C5_DTIMP		:=		SCJ->CJ_XDTIMP
		M->C5_HRIMP		:=		SCJ->CJ_XHRIMP
		M->C5_XLIBCR	:=		SCJ->CJ_XLIBCR
		M->C5_EMPDES 	:=		SCJ->CJ_EMPDES
		M->C5_FILDES	:=		SCJ->CJ_FILDES
			

		M->C5_NOMCLI	:=		SA1->A1_NOME	 // C.TORRES - 24/01/2013
		M->C5_LOJACLI	:=		SCJ->CJ_LOJA	 // C.TORRES - 24/01/2013
		M->C5_CLIENTE	:=		SCJ->CJ_CLIENTE
		M->C5_PCFRETE	:=		SCJ->CJ_PCFRET   // PERCENTUAL DE FRETE - GILBERTO RIBEIRO JUNIOR - 20/03/2013 
		M->C5_TIPOCLI	:= 		SCJ->CJ_XTIPCLI	// Tipo do Cliente estava sendo preenchido errado - Edson Hornberger - 21/01/2016

		M->C5_PCTFEIR	:=		SCJ->CJ_PCTFEIR  // PACOTE ESPECIAL DA FEIRA - GILBERTO RIBEIRO JUNIOR - 03/09/2013
		M->C5_TPPCTFE	:=		SCJ->CJ_TPPCTFE  // CODIGO DO PACOTE ESPECIAL DA FEIRA - GILBERTO RIBEIRO JUNIOR - 03/09/2013
		
		IF CEMPANT = "03"
			M->C5_X_PVBON	:= 		SCJ->CJ_X_PVBON	 // AMARRACAO DA ASSOCIACAO DE PEDIDOS REFERENTE A BONIFICACOES
		ENDIF 

		//�����������������������������������������������������������������������������
		//�ATUALIZA _ACOLS COM OS DADOS DO OR�AMENTO ANTES DE GERAR O PEDIDO DE VENDA.�
		//�����������������������������������������������������������������������������
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_OPER"} )]		:= SCK->CK_XOPER
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_XOPER"} )]		:= SCK->CK_XOPER 	//REINALDO 02/01/2013
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_FRMRC"} )]		:= SCK->CK_XFRMRC
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_FRMRCVD"} )]	:= SCK->CK_XFRMRCV
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_QTDLIB"} )]	:= SCK->CK_XQTDLIB
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_CUSTPRO"} )]	:= SCK->CK_XCUSTPR
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_DESPFIN"} )]	:= SCK->CK_XDESPFI
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_PCDEVOL"} )]	:= SCK->CK_XPCDEVO
		_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_PEDCLI"} )]	:= SCK->CK_PEDCLI
		
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	TRATAMENTO QUE ESTA SENDO REALIZADO PARA PREENCHIMENTO DA FCI NO PEDIDO DE  
		|	VENDA, POIS NO PADRAO NAO ESTA ATENDENDO.
		|	EDSON HORNBERGER - 08/10/2013.
		|=================================================================================
		*/
		
		//----------------------------------------------------------
		// PREENCHE O PERIODO DE CALCULO PARA PESQUISA NA CFD (FCI)
		// EDSON HORNBERGER - 08/10/2013
		//----------------------------------------------------------
		
		CPERCALFCI := SUBSTR(DTOS(DDATABASE),5,2) + SUBSTR(DTOS(DDATABASE),1,4)
		
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	FOI ALTERADO O FONTE PARA QUE SEJA VERIFICADO SOMENTE A EMPRESA 04 ACTION
		|	POIS A EMPRESA DAIHATSU N�O ESTA MAIS FABRICANDO PRODUTOS.
		|	
		|	EDSON HORNBERGER - 30/04/2015 (EMAIL DA PATRICIA E HENRIQUE)
		|=================================================================================
		*/		
		IF SELECT("FCI") > 0 
			
			FCI->(DBCLOSEAREA())
			
		ENDIF
		IF SELECT("FCIC") > 0 
			
			FCIC->(DBCLOSEAREA())
			
		ENDIF
		
		CQUERY := "FROM" + ENTER
		CQUERY += "CFD040 CFD" + ENTER
		CQUERY += "WHERE" + ENTER
		CQUERY += "CFD.CFD_COD = '" + SCK->CK_PRODUTO + "' AND" + ENTER
		CQUERY += "CFD.CFD_PERCAL = '" + CPERCALFCI + "' AND" + ENTER
		CQUERY += "CFD.D_E_L_E_T_ = ''"
		
		CQRYTMP := "SELECT COUNT(*) AS CNT" + ENTER + CQUERY
		
		TCQUERY CQRYTMP NEW ALIAS "FCIC"
		DBSELECTAREA("FCIC")
		
		IF FCIC->CNT > 0 
		
			FCIC->(DBCLOSEAREA())
						
			CQUERY := STRTRAN(CQUERY,"CFD010","CFD040")
			
			CQRYTMP := "SELECT COUNT(*) AS CNT" + ENTER + CQUERY
		
			TCQUERY CQRYTMP NEW ALIAS "FCIC"
			DBSELECTAREA("FCIC")
			
			IF FCIC->CNT > 0
				
				FCIC->(DBCLOSEAREA())
			
				CQRYTMP := "SELECT CFD.CFD_FCICOD, CFD.CFD_ORIGEM" + ENTER + CQUERY 
				
				TCQUERY CQRYTMP NEW ALIAS "FCI"
				DBSELECTAREA("FCI")
				
				_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_CLASFIS"})] := FCI->CFD_ORIGEM + POSICIONE("SF4",1,XFILIAL("SF4") + SCK->CK_TES ,"F4_SITTRIB") 
				_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_FCICOD"} )] := UPPER(FCI->CFD_FCICOD)
				
				FCI->(DBCLOSEAREA())
				
			ELSE
				
				DBSELECTAREA("SB1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SB1") + SCK->CK_PRODUTO)
				
				_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_CLASFIS"})] := SB1->B1_ORIGEM + POSICIONE("SF4",1,XFILIAL("SF4") + SCK->CK_TES ,"F4_SITTRIB") 
								
			ENDIF
			
		ELSE
			/*
			DEACORDO COM E-MAIL PATRICIA LIMA CASO N�O ENCONTRE NA ACTION BUSCAR A FCI NA DAIHATSU
			AUTOR: CT EM 23/06/2015
			*/
			FCIC->(DBCLOSEAREA())
						
			CQUERY := STRTRAN(CQUERY,"CFD040","CFD010")
			
			CQRYTMP := "SELECT COUNT(*) AS CNT" + ENTER + CQUERY
		
			TCQUERY CQRYTMP NEW ALIAS "FCIC"
			DBSELECTAREA("FCIC")
			
			IF FCIC->CNT > 0
				
				FCIC->(DBCLOSEAREA())
			
				CQRYTMP := "SELECT CFD.CFD_FCICOD, CFD.CFD_ORIGEM" + ENTER + CQUERY 
				
				TCQUERY CQRYTMP NEW ALIAS "FCI"
				DBSELECTAREA("FCI")
				
				_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_CLASFIS"})] := FCI->CFD_ORIGEM + POSICIONE("SF4",1,XFILIAL("SF4") + SCK->CK_TES ,"F4_SITTRIB") 
				_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_FCICOD"} )] := UPPER(FCI->CFD_FCICOD)
				
				FCI->(DBCLOSEAREA())
				
			ELSE
				
				DBSELECTAREA("SB1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SB1") + SCK->CK_PRODUTO)
				
				_ACOLS[_NAUX][ASCAN( _AHEADER, {|X| ALLTRIM(X[2]) == "C6_CLASFIS"})] := SB1->B1_ORIGEM + POSICIONE("SF4",1,XFILIAL("SF4") + SCK->CK_TES ,"F4_SITTRIB") 
								
			ENDIF
			
		ENDIF    
		
		/*
		|=================================================================================
		| FIM DO PREENCHIMENTO DO CODIGO FCI
		|=================================================================================
		*/
		

		//�����������������������Ŀ
		//�GRAVA LOG NA TABELA SZC�
		//�������������������������
		_CALIAS		:= "SCJ"
		_CCHAVE		:= XFILIAL("SCJ")+SCJ->CJ_NUM
		_DDTINI		:= DATE()
		_CHRINI		:= TIME()
		_CDTFIM		:= CTOD("")
		_CHRFIM		:= ""
		_CCODUSER	:= __CUSERID
		_CESTACAO	:= ""
		_COPERAC	:= "06 - ORCAMENTO EFETIVADO COM SUCESSO. GERADO PEDIDO DE VENDA NUMERO "+M->C5_NUM
		_cFuncao	:= "U_MTA461PV"
		U_FATMI005(_CALIAS, _CCHAVE, _DDTINI, _CHRINI, _CDTFIM, _CHRFIM, _CCODUSER, _CESTACAO, _COPERAC,_cFuncao)

		//�����������������������Ŀ
		//�GRAVA LOG NA TABELA SZC�
		//�������������������������
		_CALIAS		:= "SC5"
		_CCHAVE		:= XFILIAL("SC5")+M->C5_NUM
		_DDTINI		:= DATE()
		_CHRINI		:= TIME()
		_CDTFIM		:= CTOD("")
		_CHRFIM		:= ""
		_CCODUSER	:= __CUSERID
		_CESTACAO	:= ""
		_COPERAC	:= "06 - PEDIDO GERADO COM SUCESSO COM BASE NO ORCAMENTO: "+SCJ->CJ_NUM
		_cFuncao	:= "U_MTA461PV"
		U_FATMI005(_CALIAS, _CCHAVE, _DDTINI, _CHRINI, _CDTFIM, _CHRFIM, _CCODUSER, _CESTACAO, _COPERAC,_cFuncao)
		
	ENDIF
	
	RESTAREA(_AAREASC6)
	RESTAREA(_AAREASC5)
	RESTAREA(XSA1ALIAS)
	RESTAREA(_AAREA)
	
RETURN