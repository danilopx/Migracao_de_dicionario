#Include 'Protheus.ch'
#Include 'Rwmake.ch'

User Function TFRetUser(_CUSUARIO)

LOCAL 		LRET		:= .F.
PRIVATE 	AINFUSR 	:= {}


PSWORDER(2)
PSWSEEK(_CUSUARIO)
AINFUSR := PSWRET(NIL)

IF UPPER(AINFUSR[1][12]) = "CONTABILIDADE"
	
	LRET := .T.
	
ENDIF

RETURN(LRET)


