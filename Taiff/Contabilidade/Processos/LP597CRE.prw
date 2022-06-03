/*
ฑฑอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบExecBlock ณ LP597     บAutor  ณWALDIR ARRUDA       12/01/12        				           บฑฑ
ฑฑฬอออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  CONTABILIZAวรO DE COMPENSAวรO DE TอTULO A PAGAR CREDITO       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  TAIFF                                                                                                      บฑฑ
ฑฑอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
User Function LP597CRE()
********************
Local aAREA_ATU	:= GetArea()
Local aAREA_SE5	:= SE5->( GetArea() )
Local aAREA_SA2	:= SA2->( GetArea() )
Local aAREA_SED	:= SED->( GetArea() )
Local cConta      := ""
Local cChave      := ""

If Alltrim(SE5->E5_TIPO)$"PA"
	
	nREGATU := SE5->(RECNO())
	
	// procurando lancamento parceiro
	
	cCHAVE:= Substr(SE5->E5_DOCUMEN,1,3)+;
	Substr(SE5->E5_DOCUMEN,4,9)+;
	Substr(SE5->E5_DOCUMEN,13,2)+;
	Substr(SE5->E5_DOCUMEN,15,3)+;
	Substr(SE5->E5_DOCUMEN,18,6)+;
	Substr(SE5->E5_DOCUMEN,24,2)
	DbSelectArea("SE5")
	// E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+E5_RECPAG
	DbSetOrder(7)
	DbSeek( xFilial("SE5") + cCHAVE )

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
	
	IF ALLTRIM(SE5->E5_TIPO)=="NF".AND.SA2->A2_INTER =="S"
		cConta := "2102010003"
		
	ELSEIF ALLTRIM(SE5->E5_TIPO)$ "NF/INV".AND.SA2->A2_TIPO =="X"
		cConta := "2102020001"
	ELSE
		cConta	:= "2102010001"
	ENDIF
	
ELSEIF ALLTRIM(SE5->E5_TIPO)=="TX"
	SED->(DbSetOrder(1))
	If SED->(DbSeek( xFilial("SED") + SE5->E5_NATUREZ ))
		cConta := SED->ED_CONTA
	EndIf
Else
	
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
	
	IF ALLTRIM(SE5->E5_TIPO)=="NF".AND.SA2->A2_INTER =="S"
		cConta := "2102010003"
		
	ELSEIF ALLTRIM(SE5->E5_TIPO)$ "NF/INV" .AND.SA2->A2_TIPO =="X"
		cConta :=  "2102020001"
	ELSE
		cConta	:= "2102010001"
	ENDIF
	
EndIf

RestArea(aAREA_SE5)
RestArea(aAREA_SA2)
RestArea(aAREA_SED)
RestArea(aAREA_ATU)
Return(cConta)
