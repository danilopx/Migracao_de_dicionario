#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH' 
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT120FIM.prw
=================================================================================
||   Funcao: 	MT120FIM
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		O ponto se encontra no final da função A120PEDIDO.
|| 		Após a restauração do filtro da FilBrowse depois de fechar a operação 
|| 	realizada no pedido de compras, é a ultima instrução da função A120Pedido.
|| 		PARAMIXB[1] = Opção da Rotina de PC
||		PARAMIXB[2] = Numero do Pedido de Compras
|| 		PARAMIXB[3] = Indica se a ação foi Cancelada = 0  ou Confirmada = 1
||
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		17/02/2016
=================================================================================
=================================================================================
*/

USER FUNCTION MT120FIM()

LOCAL NOPC 	:= PARAMIXB[1]
//LOCAL CPEDIDO	:= PARAMIXB[2]
LOCAL NCANCEL	:= PARAMIXB[3]
LOCAL AAREASC7:= SC7->(GETAREA())
//LOCAL CQUERY 	:= ""
//LOCAL LCONT	:= .F.
//LOCAL NREG		:= 0 
LOCAL CVARGLB	:= "A" + ALLTRIM(UsrRetName()) + cValtoChar(THREADID())
LOCAL AREGSC7	:= {}
LOCAL I		:= 0 

IF NOPC = 5 .AND. NCANCEL = 1

	GETGLBVARS(CVARGLB,@AREGSC7)
	IF LEN(AREGSC7) > 0 
		
		FOR I := 1 TO LEN(AREGSC7)
			
			DBSELECTAREA("SD4")
			DBSETORDER(2)
			IF DBSEEK(XFILIAL("SD4") + AREGSC7[I,4] + AREGSC7[I,2])
				
				IF RECLOCK("SD4",.F.)
					
					SD4->D4__QTPCBN -= AREGSC7[I,3]
					MSUNLOCK() 
					
				ENDIF
				
			ENDIF
			 				
		NEXT I 
		
	ENDIF 		
	CLEARGLBVALUE(CVARGLB)

ENDIF 

RESTAREA(AAREASC7)

RETURN
