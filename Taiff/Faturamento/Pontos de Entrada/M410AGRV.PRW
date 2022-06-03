#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	M410AGRV.PRW
=================================================================================
||   Funcao: 	M410AGRV
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Este ponto de entrada pertence à rotina de pedidos de venda, MATA410(). 
||	Está localizado na rotina de gravação do pedido, A410GRAVA(). É executado  
||	antes da gravação das alterações.  
|| 		UTILIZADO PARA CORRIGIR O VALOR DO ICM NA APROVAÇÃO AUTOMATICA DE PEDIDOS 
||	DA EMPRESA 0301 CONFORME REGRA DEFINIDA NA ROTINA MT410OK NA ALTERAÇÃO DE 
||	PEDIDOS.
||		Sera utilizado para realizar o processo de Estorno de Transferencia de 
||	Armazens.
=================================================================================
=================================================================================
||   Autor:	WAGNER MONTENEGRO
||   Data:	28/02/2013
=================================================================================
=================================================================================
*/

USER FUNCTION M410AGRV

LOCAL NCOMISS			:= 0 
LOCAL N_NX 				:= 0
LOCAL	_CMARCAPEDIDO 	:= ""             
LOCAL XSF4ALIAS			:= SF4->(GETAREA())
LOCAL CTES				:= ""
LOCAL CQUERY 			:= ""
Local cClasFis	:= ""
Local cCFOP		:= ""
Local aDadosCfo	:= {}											// Array para montagem do tratamento do CFOP
Local lBonifIVA	:= GetNewPar("TF_IVABONIF",.F.)
Local nPosALIQMAR	:= 0
Local nPosPICMRET	:= 0
Local cMV_ESTADO	:= GetMv('MV_ESTADO')

IF  (IsInCallStack('MATA416') .OR. IsInCallStack("U_FATMI007")) .AND. (CEMPANT = '03' .OR. CEMPANT = '01')
	
	_CMARCAPEDIDO := ""
	
	IF SC5->(FIELDPOS("C5_XITEMC"))!=0
		_CMARCAPEDIDO := Alltrim(SCJ->CJ_XITEMC)
	ENDIF
	
	IF !EMPTY(M->C5_VEND1) .AND. CEMPANT="03" .AND. _CMARCAPEDIDO='PROART'
		SA3->(DBSETORDER(1))
		IF SA3->(DBSEEK( XFILIAL("SA3") + M->C5_VEND1 ))
			M->C5_COMIS1 := SA3->A3_COMIS
		ENDIF
	ELSE
		M->C5_COMIS1 = 0 // FORÇA O PREENDHIMENTO DA COMISSÃO GERAL DO PEDIDO COM O VALOR 0 - EDSON HORNBERGER - 05/12/2013
	ENDIF

	FOR N_NX:= 1 TO LEN(ACOLS)
		
		IF !EMPTY(ALLTRIM(ACOLS[N_NX][ASCAN(AHEADER,{|X| ALLTRIM(X[2])=="C6_XOPER"})]))
			If cFilAnt = "01" .and. cEmpAnt = "03"  
				cTES := aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]
				If EMPTY(cTES)
					CTES := MATESINT(2,ACOLS[N_NX][GDFIELDPOS("C6_XOPER")],M->C5_CLIENTE,M->C5_LOJACLI,"C",ACOLS[N_NX][GDFIELDPOS("C6_PRODUTO")])
			
					ACOLS[N_NX][ASCAN(AHEADER,{|X| ALLTRIM(X[2])=="C6_TES"})] := CTES
				EndIf
			Else
				CTES := MATESINT(2,ACOLS[N_NX][GDFIELDPOS("C6_XOPER")],M->C5_CLIENTE,M->C5_LOJACLI,"C",ACOLS[N_NX][GDFIELDPOS("C6_PRODUTO")])
			
				ACOLS[N_NX][ASCAN(AHEADER,{|X| ALLTRIM(X[2])=="C6_TES"})] := CTES
			EndIf
									
		ENDIF

		IF Alltrim(SCJ->CJ_XITEMC) = "TAIFF"
			//CASO NECESSÁRIO CORRIGIR COMISSAO HABILITAR AS INSTRUÇÕES ABAIXO CONFORME ROTINA MT410TOK
			NCOMISS := U_RETCOMIS(M->C5_CLIENT, M->C5_LOJACLI, M->C5_VEND1, ACOLS[N_NX][GDFIELDPOS("C6_PRODUTO")])
			IF CEMPANT != '01' .AND.  ( NCOMISS <> ACOLS[N_NX][GDFIELDPOS("C6_COMIS1")] )  .AND. !GDDELETED(N_NX) // NA DAIHATSU NAO É VALIDADA A COMISSAO SE ESTA PREENCHIDA.
				ACOLS[N_NX][GDFIELDPOS("C6_COMIS1")] := NCOMISS
				//HELP(,,'HELP',,"COMISSAO 1(C6_COMIS1) DIVERGENTE LINHA "+ LTRIM(STR(N_NX)),1,0)
			ENDIF 
		ElseIf Alltrim(SCJ->CJ_XITEMC) = "PROART"
			ACOLS[N_NX][GDFIELDPOS("C6_COMIS1")] := 0
		ENDIF
		
		IF SC5->(FIELDPOS("C5_XITEMC"))!=0
			M->C5_XITEMC := SCJ->CJ_XITEMC   
			ACOLS[N_NX][GDFIELDPOS("C6_XITEMC")] := SCJ->CJ_XITEMC   
		ENDIF

		/*
		Reforço de rotina para intervenção no efetivação do orçamento para recalculo do CFOP uma vez que foi detectado o CFOP incorreto ao nascer o pedido
		implementado em 01/02/2016 as 11:00 		
		*/
		If (cEmpAnt = "03" .And. cFilAnt $ "01|03|02") .OR. CEMPANT="01" //.and. l410Auto
		
			lOkValida := .T.
	
			/*
			If cEmpAnt+cFilAnt $ "0302" .AND. M->C5_FILDES='01'
				lOkValida := .F.
			EndIf
			*/
			
			If !EMPTY(ALLTRIM(aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})])) .AND. lOkValida
	
				If .NOT. (SB1->B1_COD == aCols[N_NX][GDFieldPOS("C6_PRODUTO")])
					SB1->(dbSetOrder(1))
					SB1->(MsSeek(xFilial('SB1') + aCols[N_NX][GDFieldPOS("C6_PRODUTO")]  ))
				EndIf
				
				If (SA1->A1_COD <> M->C5_CLIENT) .AND. .NOT. M->C5_TIPO$"DB"
					SA1->(dbSetOrder(1))
					SA1->(MsSeek(xFilial('SA1') + M->C5_CLIENT + M->C5_LOJACLI  ))
				EndIf

				aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})] := aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})]
				
				GdFieldPut("C6_OPER",aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})] ,N_NX)
				
				If IsInCallStack("U_FATMI007")
					cTES := aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]
				Else				
					/*
					Manter esta chamada da função caso seja efetivado orçamento cujo ponto de inclusão seja a rotina MATA015.
					*/
					If cFilAnt = "01" .and. cEmpAnt = "03"  
						cTES := aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})]
						If EMPTY(cTES)
							cTES := MaTesInt(2,aCols[N_NX][GDFieldPOS("C6_XOPER")],M->C5_CLIENTE,M->C5_LOJACLI,"C",aCols[N_NX][GDFieldPOS("C6_PRODUTO")])
					
							aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})] := cTES
						EndIf
					Else
						cTES := MaTesInt(2,aCols[N_NX][GDFieldPOS("C6_XOPER")],M->C5_CLIENTE,M->C5_LOJACLI,"C",aCols[N_NX][GDFieldPOS("C6_PRODUTO")])
					
						aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})] := cTES
					EndIf
				EndIf
				
				If .NOT. (SF4->F4_CODIGO == cTES)
					SF4->(dbSetOrder(1))
					SF4->(MsSeek(xFilial('SF4')+cTES ))
				EndIf
				N := N_NX
				cClasFis := CodSitTri()                                                                                         
										
				aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] := cClasFis
				
				Aadd(aDadosCfo,{"OPERNF"		, "S"				})
				Aadd(aDadosCfo,{"TPCLIFOR"	, M->C5_TIPOCLI	})
				Aadd(aDadosCfo,{"UFDEST"		, Iif(M->C5_TIPO$"DB", SA2->A2_EST,SA1->A1_EST)		})
				Aadd(aDadosCfo,{"INSCR"		, Iif(M->C5_TIPO$"DB", SA2->A2_INSCR,SA1->A1_INSCR)	})
				Aadd(aDadosCfo,{"CONTR"		, SA1->A1_CONTRIB	})
		
				cCFOP := MaFisCfo(,SF4->F4_CF,aDadosCfo)
			
				If Empty(cCFOP)
					cCFOP	:= SF4->F4_CF
				EndIf		
				
				aCols[N_NX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})] := cCFOP
			
			EndIf
			
		EndIf


		If CEMPANT = '03' .AND. CFILANT = '02' .AND. M->C5_CLASPED $ 'X| ' .AND. SA1->A1_EST=cMV_ESTADO .AND. SF7->(FIELDPOS("F7_MARBON"))!=0
			If At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND.  M->C5_TIPO = "N" .AND. SF4->F4_ISS!="S" .AND. SA1->A1_GRPTRIB='C01' .AND. lBonifIVA 
					
				nPosALIQMAR	:= aScan( aHeader,{|X| AllTrim(X[2]) == "C6_ALIQMAR"})
				nPosPICMRET	:= aScan( aHeader,{|X| AllTrim(X[2]) == "C6_PICMRET"})

				cQuery := "SELECT ISNULL(F7_MARBON,0) AS F7_MARBON " + ENTER
				cQuery += " FROM " + RetSQLName("SF7")+" SF7 " + ENTER
				cQuery += " WHERE " + ENTER
				cQuery += " F7_FILIAL = '"+xFilial("SF7")+"' " + ENTER 
				cQuery += " AND F7_GRPCLI 	= '" + SA1->A1_GRPTRIB + "' "  + ENTER
				cQuery += " AND F7_EST 		= '" + SA1->A1_EST + "' " + ENTER
				cQuery += " AND F7_GRTRIB		= '" + SB1->B1_GRTRIB + "' " + ENTER
				cQuery += " AND SF7.D_E_L_E_T_ = '' " + ENTER
	
				//MemoWrite("GFATIVAB_iva_bonificacao.SQL",cQuery)
				
				IF SELECT("AUX") > 0 
					DBSELECTAREA("AUX")
					DBCLOSEAREA()
				ENDIF 
				
				TCQUERY CQUERY NEW ALIAS "AUX"
				DBSELECTAREA("AUX")
					
				aCols[N_NX,nPosALIQMAR]	:= AUX->F7_MARBON
				aCols[N_NX,nPosPICMRET]	:= AUX->F7_MARBON
			EndIf
		EndIf


	NEXT N_NX
	
ENDIF            

_LC5LIBON  := ALLTRIM(GETSX3CACHE("C5_X_LIBON", "X3_CAMPO")) == "C5_X_LIBON"
         
IF _LC5LIBON

	IF !(__CUSERID $ GETMV("MV_X_LIBON")) .AND. ( SC5->C5_X_LIBON == "L" .OR. M->C5_X_LIBON == "L" )
	
		M->C5_X_LIBON := "X"							
	
	ENDIF
	
ENDIF 
RESTAREA(XSF4ALIAS)

RETURN
