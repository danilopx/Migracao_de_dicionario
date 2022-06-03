#Include 'Protheus.ch'
/*
=================================================================================
=================================================================================
||   Arquivo:	ACD100ET.prw
=================================================================================
||   Funcao: 	ACD100ET
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||	Remover o vinculo da ordem de separacao e pedido de venda no serial do 
||	produto na tabela ZA4
|| 
=================================================================================
=================================================================================
||   Autor:	CARLOS TORRES  
||   Data:	07/04/2017
=================================================================================
=================================================================================
*/
User Function ACD100ET()
LOCAL NNEXTRECNO
LOCAL NLASTRECNO
LOCAL NI

	If CEMPANT="03" .AND. CFILANT="02" // A validação e armazentamento do serial do produto é para o CD de EXTREMA
		dbSelectArea("ZA4")
		dbSetOrder(5)
	
		For nI := 1 to Len(aCols)
			CB8->(DbGoto(aRecno[nI]))
			ZA4->(dbSeek( xFilial("ZA4") + CB8->CB8_PROD + CB8->CB8_PEDIDO + CB8->CB8_ORDSEP ))
			While !ZA4->(Eof()) .AND. ZA4->(ZA4_FILIAL+ZA4_COD+ZA4_PEDIDO+ZA4_ORDSEP) = (xFilial("ZA4") + CB8->CB8_PROD + CB8->CB8_PEDIDO + CB8->CB8_ORDSEP)
				NLASTRECNO := ZA4->(RECNO())
				ZA4->(DBSKIP())
				NNEXTRECNO := ZA4->(RECNO())
				ZA4->(DBGOTO(NLASTRECNO))				
				ZA4->(RecLock("ZA4",.F.))
				ZA4->ZA4_PEDIDO	:= ""
				ZA4->ZA4_ORDSEP	:= ""
				ZA4->(MsUnlock())
				ZA4->(DBGOTO(NNEXTRECNO))
			End
		Next nI
		
	EndIf
	
Return

