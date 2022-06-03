#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH' 
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	VincBnf.prw
=================================================================================
||   Funcao: 	VincBnf
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER  
||   Data:	07/12/2015	
=================================================================================
=================================================================================
*/

USER FUNCTION VINCBNF(CPEDVINC,CNUMPED,NOPTION,CLASSPED)

LOCAL AAREASC5 	:= SC5->(GETAREA())
LOCAL AAREA 		:= GETAREA()
LOCAL CPEDBON		:= ""
LOCAL NVALOR		:= 0
LOCAL LACHOU		:= .F.
LOCAL AANTES		:= {}
LOCAL ADEPOIS		:= {}
LOCAL ATRATAR		:= {}
LOCAL I 			:= 0 

DO CASE
	
	CASE CLASSPED = 'V'
		IF NOPTION = 3 //INCLUSAO
			
			MSGSTOP("O campo de Pedido Vinc. Bonificação não deve ser preechido!" + ENTER + "Ao criar o Pedido de Bonificação informe o Número de Portal deste Pedido.","ATENÇÃO")
			RETURN()
						
		ENDIF 
		
	CASE CLASSPED = 'X'
		DBSELECTAREA("SC5")
		DBORDERNICKNAME("SC5NUMOLD")
		IF DBSEEK(XFILIAL("SC5") + ALLTRIM(CPEDVINC))
			IF NOPTION = 3 //INCLUSAO
				CPEDBON := ALLTRIM(SC5->C5_X_PVBON) 
				CPEDBON += IIF(RIGHT(CPEDBON,1) != '/' .AND. !EMPTY(CPEDBON),'/' + ALLTRIM(M->C5_NUMOLD),ALLTRIM(M->C5_NUMOLD))
				IF RECLOCK("SC5",.F.)
					
					SC5->C5_X_PVBON := CPEDBON
					MSUNLOCK()
					
				ENDIF
				
				FOR I := 1 TO LEN(ACOLS)
					
					NVALOR += (ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] * ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})])
					
				NEXT I 
				  
				IF RECLOCK("SZ0",.T.)
					
					SZ0->Z0_FILIAL 	:= XFILIAL("SZ0")
					SZ0->Z0_CLIENTE	:= M->C5_CLIENTE 
					SZ0->Z0_LOJA 		:= M->C5_LOJACLI
					SZ0->Z0_VENOLD 	:= ALLTRIM(CPEDVINC)
					SZ0->Z0_BONOLD 	:= ALLTRIM(M->C5_NUMOLD)
					SZ0->Z0_VALOR 	:= NVALOR

					MSUNLOCK()
					
				ENDIF
				
			ELSEIF NOPTION = 4 //ALTERACAO
				/*
				|---------------------------------------------------------------------------------
				|	NA ALTERAÇÃO VERIFICA SE PRECISAR EXCLUIR O CONTROLE NA TABELA SZ0
				|---------------------------------------------------------------------------------
				*/ 
				RESTAREA(AAREASC5)
				CPEDBON 	:= ALLTRIM(SC5->C5_X_PVBON)
				AANTES 	:= STRTOKARR(CPEDBON,"/")
				ADEPOIS	:= STRTOKARR(ALLTRIM(M->C5_X_PVBON),"/")
				IF LEN(AANTES) > LEN(ADEPOIS)
					FOR I := 1 TO LEN(AANTES)
						
						IF ASCAN(ADEPOIS,{|X| X[1] = AANTES[I]}) = 0
							
							AADD(ATRATAR,{AANTES[I]})
							
						ENDIF 						
						
					NEXT I
					
				ENDIF 
				
				IF LEN(ATRATAR) > 0 
					
					FOR I := 1 TO LEN(ATRATAR)
						
						DBSELECTAREA("SZ0")
						DBSETORDER(1)
						IF DBSEEK(XFILIAL("SZ0") + M->C5_CLIENTE + M->C5_LOJACLI + ATRATAR[I,1])
							
							IF RECLOCK("SZ0",.F.)
								DBDELETE()
								MSUNLOCK()
							ENDIF 							
							
						ENDIF
						
					NEXT I  
					
				ENDIF  
				/*
				|---------------------------------------------------------------------------------
				|	CRIA CONTROLE INTERNO DE SALDO A BONIFICAR
				|---------------------------------------------------------------------------------
				*/
				IF !(ALLTRIM(M->C5_NUMOLD) $ CPEDBON) 
					CPEDBON += IIF(RIGHT(CPEDBON,1) != '/' .AND. !EMPTY(CPEDBON),'/' + ALLTRIM(M->C5_NUMOLD),ALLTRIM(M->C5_NUMOLD))
					
					FOR I := 1 TO LEN(ACOLS)
					
						NVALOR += (ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] * ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})])
						
					NEXT I 
					
					IF !EMPTY(ALLTRIM(CPEDVINC))
					
						IF RECLOCK("SZ0",.T.)
						
							SZ0->Z0_FILIAL 	:= XFILIAL("SZ0")
							SZ0->Z0_CLIENTE	:= M->C5_CLIENTE 
							SZ0->Z0_LOJA 		:= M->C5_LOJACLI
							SZ0->Z0_VENOLD 	:= ALLTRIM(CPEDVINC)
							SZ0->Z0_BONOLD 	:= ALLTRIM(M->C5_NUMOLD)
							SZ0->Z0_VALOR 	:= NVALOR
		
							MSUNLOCK()
							
						ENDIF
						
					ENDIF 
					
				ENDIF
				IF RECLOCK("SC5",.F.)
					
					SC5->C5_X_PVBON := ALLTRIM(M->C5_X_PVBON)
					MSUNLOCK()
					
				ENDIF					
			
			ELSEIF NOPTION = 1 //EXCLUSAO
				CPEDBON := ALLTRIM(SC5->C5_X_PVBON)
				IF (ALLTRIM(M->C5_NUMOLD) $ CPEDBON) 
					CPEDBON := STRTRAN(CPEDBON,ALLTRIM(M->C5_NUMOLD),"")
					CPEDBON := STRTRAN(CPEDBON,"//","/")
					CPEDBON := IIF(LEFT(CPEDBON,1) = "/",SUBSTR(CPEDBON,2,LEN(CPEDBON)-1),CPEDBON)
				ENDIF
				IF RECLOCK("SC5",.F.)
					
					SC5->C5_X_PVBON := CPEDBON
					MSUNLOCK()
					
				ENDIF
				
				DBSELECTAREA("SZ0")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SZ0") + M->C5_CLIENTE + M->C5_LOJACLI + ALLTRIM(CPEDVINC))
				
					WHILE SZ0->(!EOF()) .AND. SZ0->Z0_VENOLD = ALLTRIM(CPEDVINC)
						
						IF ALLTRIM(SZ0->Z0_BONOLD) = ALLTRIM(M->C5_NUMOLD)
							
							LACHOU := .T.
							EXIT
							
						ENDIF
						SZ0->(DBSKIP())  
						
					ENDDO 
					
					IF LACHOU 
						
						IF RECLOCK("SZ0",.F.)
							
							DBDELETE()
							MSUNLOCK()
							
						ENDIF
						
					ELSE
						
						IF RECLOCK("SZ0",.T.)
						
							SZ0->Z0_FILIAL 	:= XFILIAL("SZ0")
							SZ0->Z0_CLIENTE	:= M->C5_CLIENTE 
							SZ0->Z0_LOJA 		:= M->C5_LOJACLI
							SZ0->Z0_VENOLD 	:= ALLTRIM(CPEDVINC)
							SZ0->Z0_BONOLD 	:= ALLTRIM(M->C5_NUMOLD)
							SZ0->Z0_VALOR 	:= -NVALOR
		
							MSUNLOCK()
							
						ENDIF
						
					ENDIF 
					
				ELSE
					
					FOR I := 1 TO LEN(ACOLS)
					
						NVALOR += (ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] * ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})])
						
					NEXT I 
					
					IF RECLOCK("SZ0",.T.)
						
						SZ0->Z0_FILIAL 	:= XFILIAL("SZ0")
						SZ0->Z0_CLIENTE	:= M->C5_CLIENTE 
						SZ0->Z0_LOJA 		:= M->C5_LOJACLI
						SZ0->Z0_VENOLD 	:= ALLTRIM(CPEDVINC)
						SZ0->Z0_BONOLD 	:= ALLTRIM(M->C5_NUMOLD)
						SZ0->Z0_VALOR 	:= -NVALOR
	
						MSUNLOCK()
						
					ENDIF 
					
				ENDIF
				
			ENDIF 
		
		ENDIF 		 		
		
		
ENDCASE
RESTAREA(AAREA)
	
RETURN()
