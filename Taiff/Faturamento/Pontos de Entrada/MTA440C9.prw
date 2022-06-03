#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MTA440C9.prw
=================================================================================
||   Funcao: 	MTA440C9
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		LIBERACAO DO PEDIDO DE VENDA
||		Chamado na gravacao e liberacao do pedido de Venda, apos a atualizacao  
|| 	do acumulados do SA1.
|| 		P.E. para todos os itens do pedido.
|| 		FORCA A LIBERACAO DE CREDITO NAS EMPRESAS QUE USAM AVALIAÇÃO DE 
||	CRÉDITO MULTI EMPRESA
=================================================================================
=================================================================================
||   Autor:	THIAGO COMELLI
||   Data:	10/12/12
=================================================================================
=================================================================================
*/

USER FUNCTION MTA440C9()

LOCAL CQUERY	:= ""
LOCAL NTOTSC6	:= 0
LOCAL NTOTSC9	:= 0
LOCAL LINTERC	:= .F.
Local cNomRotina	:= ""

LWEB := Select("SX6") == 0

	/*
	|---------------------------------------------------------------------------------
	|	Realiza a validacao do Cliente verificando se eh do Grupo.
	|---------------------------------------------------------------------------------
	*/
	IF 	CEMPANT="03"
		CQUERY := "SELECT '.T.' AS EXISTE FROM SM0_COMPANY WHERE M0_CGC = '" + POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC") + "'"
		IF SELECT("EMP") > 0 
			DBSELECTAREA("EMP")
			DBCLOSEAREA()
		ENDIF 
		TCQUERY CQUERY NEW ALIAS "EMP"
		DBSELECTAREA("EMP")
		DBGOTOP()
		LINTERC := EMP->EXISTE
		LINTERC := IIF(EMPTY(ALLTRIM(LINTERC)),.F.,.T.)	
	
		IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__MULT06",.F.,"")
			IF RECLOCK("SC9",.F.)
				IF SC5->C5_XLIBCR == 'L'
					SC9->C9_BLCRED  := ""
				ELSE
					SC9->C9_BLCRED  := "09"
				ENDIF
				SC9->(MSUNLOCK())
			ENDIF
		ENDIF
				
		If SC5->(FIELDPOS("C5__DTLIBF")) > 0 
			IF IsInCallStack("MATA440") .OR. IsInCallStack("MATA521") .OR. IsInCallStack("MATA521A")
				If SC9->C9_LOCAL = "21"
					cNomRotina := Iif(IsInCallStack("MATA521"),"MATA521",Iif(IsInCallStack("MATA521A"),"MATA521","MATA440"))
					IF SC9->(RECLOCK("SC9",.F.))
						SC9->C9_BLINF  := cNomRotina + "-" + Upper(Rtrim(CUSERNAME)) + " " + DTOC(dDatabase) + " " + Time()
						SC9->(MSUNLOCK())
					ENDIF
					If SC5->(RecLock("SC5",.F.))
						SC5->C5__DTLIBF	:= dDataBase
						SC5->C5__BLOQF		:= "" 
						SC5->C5_ULIB5		:= Upper(Rtrim(Substr(cusuario,7,15)))
						SC5->C5_DLIB5		:= dDatabase
						SC5->C5_HLIB5		:= Left(Time(),5)
						SC5->C5_PLIB5		:= cNomRotina
						SC5->C5__LIBM		:= "M"				
						SC5->(MsUnlock())
					EndIf
					If SC6->(RecLock("SC6",.F.))
						SC6->C6__BLINF		:= cNomRotina + "-" + Upper(Rtrim(CUSERNAME)) + " " + DTOC(dDatabase) + " " + Time()
						SC6->(MsUnlock())
					EndIf
				EndIf
			Else
				IF .NOT. IsInCallStack("A410COPIA")
					If AT("ESTORNO",ALLTRIM(SC5->C5_MENNOTA))!=0
						lWeb := .F.
					EndIf
					If SC9->(RecLock("SC9",.F.))
					 	If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC9->C9_LOCAL = "21" .AND. SC5->C5_TIPO = "N"  
							SC9->C9_BLINF	:= "ESTMI001-" + IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME))) +" "+DTOC(dDatabase)+" "+Time()
						EndIf
						SC9->C9_PEDORI	:= SC5->C5_NUMORI
						SC9->C9_CLIORI	:= SC5->C5_CLIORI
						SC9->C9_LOJORI	:= SC5->C5_LOJORI
						SC9->C9_NOMORI	:= SC5->C5_NOMORI
						SC9->(MsUnlock())
					EndIf
				EndIf
			EndIf
		EndIf
		
		/*
		|---------------------------------------------------------------------------------
		|	GRAVACAO DOS CAMPOS DE CONTROLE DO NOVO PROCESSO DE CROSSDOCKING
		|---------------------------------------------------------------------------------
		*/
		IF .NOT. EMPTY(SC5->C5_NUMOC) .AND. (CEMPANT+CFILANT) != (SC5->C5_EMPDES + SC5->C5_FILDES) .AND. (IsInCallStack("MATA440") .Or. IsInCallStack("U_FATMI006"))  .AND. ALLTRIM(SC5->C5_CLASPED) $ "V|X"
		
			IF RECLOCK("SC9",.F.)
				
				SC9->C9_PEDORI := SC5->C5_NUMORI
				SC9->C9_CLIORI := SC5->C5_CLIORI
				SC9->C9_LOJORI := SC5->C5_LOJORI
				SC9->C9_NOMORI := SC5->C5_NOMORI
				SC9->(MSUNLOCK())
				
			ENDIF 
			
			/*
			|---------------------------------------------------------------------------------
			|	Calcula a quantidade Vendida
			|---------------------------------------------------------------------------------
			*/
			CQUERY := "SELECT" 										+ ENTER
			CQUERY += "	SUM(C6_QTDVEN) AS QTDVEN" 					+ ENTER 
			CQUERY += "FROM" 										+ ENTER 
			CQUERY += "	" + RETSQLNAME("SC6") 						+ ENTER
			CQUERY += "WHERE" 										+ ENTER
			CQUERY += "	C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER
			CQUERY += "	C6_NUM = '" + SC5->C5_NUM + "' AND" 		+ ENTER
			CQUERY += "	D_E_L_E_T_ = ''"							+ ENTER 
			CQUERY += "GROUP BY" 									+ ENTER 
			CQUERY += "	C6_NUM"
			
			IF SELECT("TMP") > 0 
				
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
				
			ENDIF 
			
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			
			NTOTSC6 := TMP->QTDVEN
			
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
							
			/*
			|---------------------------------------------------------------------------------
			|	Calcula a quantidade Liberada
			|---------------------------------------------------------------------------------
			*/
			CQUERY := "SELECT" 										+ ENTER
			CQUERY += "	SUM(C9_QTDLIB) AS QTDLIB" 					+ ENTER 
			CQUERY += "FROM" 										+ ENTER 
			CQUERY += "	" + RETSQLNAME("SC9") 						+ ENTER
			CQUERY += "WHERE" 										+ ENTER
			CQUERY += "	C9_FILIAL = '" + XFILIAL("SC9") + "' AND" 	+ ENTER
			CQUERY += "	C9_PEDIDO = '" + SC5->C5_NUM + "' AND" 		+ ENTER
			CQUERY += "	C9_NFISCAL = '' AND" 						+ ENTER
			CQUERY += "	D_E_L_E_T_ = ''"							+ ENTER 
			CQUERY += "GROUP BY" 									+ ENTER 
			CQUERY += "	C9_PEDIDO"
	
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			
			NTOTSC9 := TMP->QTDLIB		
			
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			
			/*
			|---------------------------------------------------------------------------------
			|	Altera o Status do Pedido de Vendas na Empresa TaiffProart Matriz
			|---------------------------------------------------------------------------------
			*/
			CQUERY := "UPDATE" 									+ ENTER
			CQUERY += "	SC5" 									+ ENTER
			CQUERY += "SET" 									+ ENTER
			IF (NTOTSC6 - NTOTSC9) != 0  
				CQUERY += "	C5_STCROSS = 'LIBPAR'" 					+ ENTER 
			ELSE
				CQUERY += "	C5_STCROSS = 'LIBTOT'" 					+ ENTER
			ENDIF
			CQUERY += "FROM" 									+ ENTER 
			CQUERY += "	" + RETSQLNAME("SC5") + " SC5"			+ ENTER 
			CQUERY += "WHERE" 									+ ENTER 
			CQUERY += "	C5_FILIAL = '01' AND" 					+ ENTER 
			CQUERY += "	C5_NUM = '" + SC5->C5_NUMORI + "' AND" 	+ ENTER 
			CQUERY += "	D_E_L_E_T_ = ''"
			
			IF TCSQLEXEC(CQUERY) != 0 
				
				MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas na Matriz!")  + ENTER + ;
									"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
				
			ENDIF 
		
		ELSEIF (CEMPANT + CFILANT ) = "0301" .AND. !LINTERC .AND. ALLTRIM(SC5->C5_CLASPED) $ "V|X"
		
			/*
				ATUALIZAR STATUS SOMENTE SE FOR PEDIDO DE CROSS DOCKING
			*/
	
			CQUERY := "SELECT" 										+ ENTER
			CQUERY += "	COUNT(*) AS QTDVEN" 						+ ENTER 
			CQUERY += "FROM" 											+ ENTER 
			CQUERY += "	" + RETSQLNAME("SC5") 					+ ENTER
			CQUERY += "WHERE" 										+ ENTER
			CQUERY += "	C5_FILIAL = '02'" 						+ ENTER
			CQUERY += "	AND C5_NUMORI = '" + SC5->C5_NUM + "'" 	+ ENTER
			CQUERY += "	AND D_E_L_E_T_ = ''"						+ ENTER 
			
			IF SELECT("TMP") > 0 
				
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
				
			ENDIF 
			
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			
			NTOTSC6 := TMP->QTDVEN
			
			If NTOTSC6 > 0 	
				RECLOCK("SC5",.F.)
				SC5->C5_STCROSS := "AGFATU"
				SC5->(MSUNLOCK())
			EndIf		
		ENDIF 
	ENDIF	
RETURN

