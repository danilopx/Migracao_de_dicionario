#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================
=================================================================================
||   Arquivo: MTA040MNU.PRW
=================================================================================
||   Funcao: MTA040MNU
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Ponto de Entrada para criar novos Botoes no Menu do Cadastro de 
|| 	Vendedores.
|| 		Esta sendo utilizado para tirar o Botao Incluir quando for a Empresa 
|| 	Proart.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		05/12/2013
=================================================================================
=================================================================================
*/

USER FUNCTION MTA040MNU()

	LOCAL NPOSINC 	:= 0
	LOCAL ATEMP		:= {}
	LOCAL I			:= 0
	
	IF !IsInCallStack("U_CADSA3")
	
		NPOSINC := ASCAN(AROTINA,{|X| X[2] == "A040Inclui"})
		
		IF NPOSINC > 0 .AND. CEMPANT = "03"
			
			ADEL(AROTINA,NPOSINC)
			
		ENDIF 
		
		FOR I := 1 TO LEN(AROTINA)
			
			IF VALTYPE(AROTINA[I]) <> "U" 
				
				AADD(ATEMP,AROTINA[I])
				
			ENDIF
			
		NEXT I 
	
		AROTINA := {}
		AROTINA := ACLONE(ATEMP)
		
	ENDIF

RETURN

