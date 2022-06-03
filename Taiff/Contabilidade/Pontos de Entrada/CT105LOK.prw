#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	CT105LOK.prw
=================================================================================
||   Funcao: 	CT105LOK
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		O ponto de entrada CT105LOK é utilizado na função de validação da 
|| 	linhaOk da Getdados Function CT105LOK.
|| 		Iremos realizar a validacao do Grupo de Contas do Centro de Custo em 
|| 	relacao com a Conta que esta sendo classificada.
|| 
=================================================================================
=================================================================================
||   Autor: Edson Hornberger
||   Data:	22/07/2015
=================================================================================
=================================================================================
*/

USER FUNCTION CT105LOK()

LOCAL AAREA 		:= GETAREA()
LOCAL AAREATMP   	:= TMP->(GETAREA())
LOCAL LRET 			:= .T.
LOCAL CMSG			:= ""
LOCAL NCODIGO		:= 0 
Local cParFil		:= ""

If cfilant == "01" .And. cempant == "01"
	cParFil := "1"
ElseIf cfilant == "02" .And. cempant == "01"
	cParFil := "2"
ElseIf cfilant == "01" .And. cempant == "03"
	cParFil := "3"
ElseIf cfilant == "02" .And. cempant == "03"
	cParFil := "4"
ElseIf cfilant == "03" .And. cempant == "03"
	cParFil := "5"
ElseIf cfilant == "01" .And. cempant == "04"
	cParFil := "6"
ElseIf cfilant == "02" .And. cempant == "04"
	cParFil := "7"
ElseIf cfilant == "01" .And. cempant == "02"
	cParFil := "8"
ElseIf cfilant == "02" .And. cempant == "02"
	cParFil := "9"
ElseIf cfilant == "03" .And. cempant == "04"
	cParFil := "A"
EndIf

DO CASE  
	
	/*
	|---------------------------------------------------------------------------------
	| Verifica se o campo de Centro de Custo Debito esta preenchido. Caso esteja, 
	| valida se o Grupo eh compatível com a Conta Debito
	|---------------------------------------------------------------------------------
	*/
	CASE !EMPTY(ALLTRIM(TMP->CT2_CCD))
		
		/*
		|---------------------------------------------------------------------------------
		|	Se for conta de Resultado não realiza validação.
		|---------------------------------------------------------------------------------
		*/
		IF POSICIONE("CT1", 1, XFILIAL("CT1") + TMP->CT2_DEBITO, "CT1_NATCTA") = '05' 
			
			RETURN(LRET) 
			
		ENDIF 
	
		DBSELECTAREA("CTT")
		DBSETORDER(1)
		DBGOTOP()
		IF DBSEEK(XFILIAL("CTT") + TMP->CT2_CCD)
		
			/*
			|---------------------------------------------------------------------------------
			|	Se o campo de Grupo de Contas não estiver preenchido não realiza validação
			|---------------------------------------------------------------------------------
			*/
			IF EMPTY(ALLTRIM(CTT->CTT_XGRPCC))
				
				RETURN(LRET)
				
			ENDIF 
			
			IF CTT->CTT_CCTIPO = '2'
				NCODIGO := 3
			ELSE
				NCODIGO := 4
			ENDIF		
			IF SUBSTR(TMP->CT2_DEBITO,1,NCODIGO) != ALLTRIM(CTT->CTT_XGRPCC)
				
				CMSG := "O Centro de Custo " + TMP->CT2_CCD + " só pode ser utilizado com as Contas Iniciadas com " + ALLTRIM(CTT->CTT_XGRPCC) + "!" + ENTER 
				CMSG += "Corrija o lançamento!"
				MSGALERT(CMSG,"Lançamento com Problema!")
				LRET := .F.
				
			ENDIF			
			If LRET
				If CTT->(FIELDPOS("CTT_FILUSO")) != 0 
					If AT( cParFil , CTT->CTT_FILUSO ) = 0
						MsgAlert("Centro de custo não permite uso nesta empresa")
						LRET := .F.
					EndIf
				EndIf					 
			EndIf
			
		ELSE
			
			CMSG := "Centro de Custo informado (" + ALLTRIM(TMP->CT2_CCD) + ") não encontrado!"
			MSGALERT(CMSG,"Lançamento com Problema!")
			LRET := .F.
			
		ENDIF
		
	/*
	|---------------------------------------------------------------------------------
	| Verifica se o campo de Centro de Custo Credito esta preenchido. Caso esteja, 
	| valida se o Grupo eh compatível com a Conta Credito
	|---------------------------------------------------------------------------------
	*/
	CASE !EMPTY(ALLTRIM(TMP->CT2_CCC))
		
		/*
		|---------------------------------------------------------------------------------
		|	Se for conta de Resultado não realiza validação.
		|---------------------------------------------------------------------------------
		*/
		IF POSICIONE("CT1", 1, XFILIAL("CT1") + TMP->CT2_DEBITO, "CT1_NATCTA") = '05' 
			
			RETURN(LRET) 
			
		ENDIF 
	
		DBSELECTAREA("CTT")
		DBSETORDER(1)
		DBGOTOP()
		IF DBSEEK(XFILIAL("CTT") + TMP->CT2_CCC)
		
			/*
			|---------------------------------------------------------------------------------
			|	Se o campo de Grupo de Contas não estiver preenchido não realiza validação
			|---------------------------------------------------------------------------------
			*/
			IF EMPTY(ALLTRIM(CTT->CTT_XGRPCC))
				
				RETURN(LRET)
				
			ENDIF 
			
			IF CTT->CTT_CCTIPO = '2'
				NCODIGO := 3
			ELSE
				NCODIGO := 4
			ENDIF
			IF SUBSTR(TMP->CT2_CREDIT,1,NCODIGO) != ALLTRIM(CTT->CTT_XGRPCC)
				
				CMSG := "O Centro de Custo " + TMP->CT2_CCD + " só pode ser utilizado com as Contas Iniciadas com " + ALLTRIM(CTT->CTT_XGRPCC) + "!" + ENTER 
				CMSG += "Corrija o lançamento!"
				MSGALERT(CMSG,"Lançamento com Problema!")
				LRET := .F.
				
			ENDIF
			If LRET
				If CTT->(FIELDPOS("CTT_FILUSO")) != 0 
					If AT( cParFil , CTT->CTT_FILUSO ) = 0
						MsgAlert("Centro de custo não permite uso nesta empresa")
						LRET := .F.
					EndIf
				EndIf					 
			EndIf
			
		ELSE
			
			CMSG := "Centro de Custo informado (" + ALLTRIM(TMP->CT2_CCC) + ") não encontrado!"
			MSGALERT(CMSG,"Lançamento com Problema!")
			LRET := .F.
			
		ENDIF
		
ENDCASE

RESTAREA(AAREATMP)
RESTAREA(AAREA)

RETURN(LRET)
